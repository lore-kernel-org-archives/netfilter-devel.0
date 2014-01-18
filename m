From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: new xtables-addons implementation of XOR target
Date: Sat, 18 Jan 2014 12:28:56 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401181207260.18964@nerf08.vanv.qr>
References: <CADb65V65-OHkHCpoqmXZgqq=h3c7sRuEdzfNbRY5TeirfP2OPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andrew Smith <iamasmith.home@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:38516 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaARL27 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:28:59 -0500
In-Reply-To: <CADb65V65-OHkHCpoqmXZgqq=h3c7sRuEdzfNbRY5TeirfP2OPQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2014-01-18 11:25, Andrew Smith wrote:
>
>I had a requirement for some proof of concept work I was performing to
>have a very simple layer 3 obfuscation so it was useful to me and 
>perhaps others

If you can give more details, others could actually ascertain this 
usefulness.
1.47 is basically unmaintained but you can send pull requests,
which seems also preferable given Gmail corrupts everybody's patches.

>+{
>+ printf(
>+ "XOR target options:\n"
>+ "    --key <string>\n"
>+ "    --block-size <size>\n"
>+ );
>+}
>+
>+static int
>+xor_parse(int c, char **argv, int invert, unsigned int *flags,
>+                  const void *entry, struct xt_entry_target **target)
>+{
>+ struct xt_xor_info *info = (void *)(*target)->data;
>+        unsigned long v;
>+
>+ switch (c) {
>+ case 'k':
>+                if (strlen(optarg) > sizeof(info->key))
>+ xtables_error(PARAMETER_PROBLEM, "XOR: Maximum key size is
>%zu",sizeof(info->key));
>+ strncpy(info->key, optarg, sizeof(info->key));
>+                *flags |= FLAGS_KEY;
>+ return true;
>+        case 'b':
>+ if (!xtables_strtoul(optarg, NULL, &v, 1, 5))
>+ xtables_param_act(XTF_BAD_VALUE, "XOR",
>+ "--block-size", optarg);
>+                info->block_size = v;
>+                *flags |= FLAGS_BLOCK;
>+                return true;
>+ }
>+ return false;
>+}
>+static void xor_check(unsigned int flags)
>+{
>+ if (!(flags & FLAGS_KEY))
>+ xtables_error(PARAMETER_PROBLEM, "XOR: "
>+ "\"--key\" is required.");
>+ if (!(flags & FLAGS_BLOCK))
>+ xtables_error(PARAMETER_PROBLEM, "XOR: "
>+ "\"--block-size\" is required.");
>+}
