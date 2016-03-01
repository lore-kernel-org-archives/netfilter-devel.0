From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_owner: Add translation to nft
Date: Wed, 2 Mar 2016 00:47:26 +0530
Message-ID: <20160301191726.GA15217@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34339 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbcCATRi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:17:38 -0500
Received: by mail-pf0-f171.google.com with SMTP id 4so39688193pfd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 11:17:37 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id 85sm47331726pfl.18.2016.03.01.11.17.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 11:17:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module owner to nftables.
Full translation of this match awaits the support for --socket-exists
option.

Examples:

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner shivani -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_owner.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index d9adc12..d81080a 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -492,6 +492,62 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
 }
 
+static void
+owner_mt_print_item_xlate(const struct xt_owner_match_info *info,
+			  const char *label, uint8_t flag,
+			  struct xt_xlate *xl, bool numeric)
+{
+	if (!(info->match & flag))
+		return;
+
+	xt_xlate_add(xl, "%s%s", label, info->invert & flag ? "!= " : "");
+
+	switch (info->match & flag) {
+	case XT_OWNER_UID:
+		if (info->uid_min != info->uid_max) {
+			xt_xlate_add(xl, "%u-%u ", (unsigned int)info->uid_min,
+				     (unsigned int)info->uid_max);
+			break;
+		} else if (!numeric) {
+			const struct passwd *pwd = getpwuid(info->uid_min);
+
+			if (pwd != NULL && pwd->pw_name != NULL) {
+				xt_xlate_add(xl, " %s", pwd->pw_name);
+				break;
+			}
+		}
+		xt_xlate_add(xl, "%u ", (unsigned int)info->uid_min);
+		break;
+
+	case XT_OWNER_GID:
+		if (info->gid_min != info->gid_max) {
+			xt_xlate_add(xl, "%u-%u ", (unsigned int)info->gid_min,
+				     (unsigned int)info->gid_max);
+			break;
+		} else if (!numeric) {
+			const struct group *grp = getgrgid(info->gid_min);
+
+			if (grp != NULL && grp->gr_name != NULL) {
+				xt_xlate_add(xl, "%s ", grp->gr_name);
+				break;
+			}
+		}
+		xt_xlate_add(xl, "%u ", (unsigned int)info->gid_min);
+		break;
+	}
+}
+
+static int owner_mt_xlate(const struct xt_entry_match *match,
+			  struct xt_xlate *xl, int numeric)
+{
+	const struct xt_owner_match_info *info = (void *)match->data;
+
+	owner_mt_print_item_xlate(info, "skuid ", XT_OWNER_UID, xl, true);
+	owner_mt_print_item_xlate(info, "skgid ", XT_OWNER_GID, xl, true);
+
+	return 1;
+}
+
 static struct xtables_match owner_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -534,6 +590,7 @@ static struct xtables_match owner_mt_reg[] = {
 		.print         = owner_mt_print,
 		.save          = owner_mt_save,
 		.x6_options    = owner_mt_opts,
+		.xlate	       = owner_mt_xlate,
 	},
 };
 
-- 
1.9.1

