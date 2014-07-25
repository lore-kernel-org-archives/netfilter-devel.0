From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: add optional [seconds] argument to -w
Date: Fri, 25 Jul 2014 19:08:21 +0200
Message-ID: <20140725170821.GA5618@salvia>
References: <1404481841-20084-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbaGYRIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:08:19 -0400
Content-Disposition: inline
In-Reply-To: <1404481841-20084-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 03:50:41PM +0200, Jiri Popelka wrote:
> This patch adds an optional numeric argument
> to -w option (added with 93587a0) so one can
> specify how long to wait for an exclusive lock.
> 
> If the value isn't specified it works as before,
> i.e. program waits indefinitely.
> 
> If user specifies it, program exits after
> the given time interval passes.
> 
> This patch also adds the -w/--wait to nftables
> compat code, so the parser doesn't complain.

Applied.

I had to fix iptables-compat though:

# iptables-compat -I INPUT -w 3 -j ACCEPT
Bad argument `3'
Try `iptables -h' or 'iptables --help' for more information.

I have collapsed the following patch to yours.

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/iptables/xtables.c b/iptables/xtables.c
index f7b1a75..d661dd1 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -684,6 +684,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 {
 	struct iptables_command_state cs;
 	int verbose = 0;
+	int wait = 0;
 	const char *chain = NULL;
 	const char *policy = NULL, *newname = NULL;
 	unsigned int rulenum = 0, command = 0;
@@ -1008,6 +1009,15 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 					      "You cannot use `-w' from "
 					      "iptables-restore");
 			}
+			if (optarg) {
+				if (sscanf(optarg, "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						      "wait seconds not numeric");
+			} else if (optind < argc && argv[optind][0] != '-'
+				   && argv[optind][0] != '!')
+				if (sscanf(argv[optind++], "%i", &wait) != 1)
+					xtables_error(PARAMETER_PROBLEM,
+						      "wait seconds not numeric");
 			break;
 
 		case '0':

--envbJBWh7q8WU6mo--
