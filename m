From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: childlevel's pom comment
Date: Thu, 4 Mar 2004 15:10:37 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0403041500280.10634@dsl093-017-216.msp1.dsl.speakeasy.net>
References: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
 <40469E10.7080100@trash.net> <Pine.LNX.4.60.0403032150000.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
 <4046BFB9.809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4046BFB9.809@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I would prefer if "any" wouldn't need to be matched in the kernel,
> something like:
>
> if (info->name[0] == '\0')
>        ret = !info->invert;
> else
>        ...
>
> and have userspace do the "any" <=> "" translation.

That would be fine with me, but iptables seems to consider the empty
string to be an error condition:

--- libipt_helper.c.old 2004-03-03 21:39:07.000000000 -0600
+++ libipt_helper.c     2004-03-04 14:50:13.408377032 -0600
@@ -46,6 +47,12 @@
        case '1':
                check_inverse(optarg, &invert, &invert, 0);
                strncpy(info->name, optarg, 29);
+
+               /* special case, translate "any" to "" so the kernel
+               doesn't have to run strcmp. */
+               if(!strcmp(info->name, "any"))
+                       info->name[0] = '\0';
+
                if (invert)
                        info->invert = 1;
                *flags = 1;


root@quadong# iptables -A POSTROUTING -t mangle -m helper --helper any
iptables: Invalid argument

It seems like I'd have to make significantly more invasive changes than
are really called for to get it to accept an empty string.  What do you
think?

-matthew
