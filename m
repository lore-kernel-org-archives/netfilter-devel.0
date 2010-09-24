From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] secmark: do not return early if there was no error
Date: Fri, 24 Sep 2010 23:01:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009242300400.3599@obet.zrqbmnf.qr>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, paul.moore@hp.com, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 2010-09-24 22:45, Eric Paris wrote:

>Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
>netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
>on 0 (aka no error) early and didn't finish setting up secmark.  This results
>in a kernel BUG if you use SECMARK.

>+++ b/net/netfilter/xt_SECMARK.c
>@@ -101,7 +101,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
> 	switch (info->mode) {
> 	case SECMARK_MODE_SEL:
> 		err = checkentry_selinux(info);
>-		if (err <= 0)
>+		if (err)
> 			return err;

Indeed the = is unwanted and err < 0 was intended here.
Sorry for the slip.
