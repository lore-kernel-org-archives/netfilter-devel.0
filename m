From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/2] osf: fixed matching bug.
Date: Sun, 22 Aug 2004 00:12:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127C8DD.2080406@trash.net>
References: <20040822010353.34801a4f@zanzibar.2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20040822010353.34801a4f@zanzibar.2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Evgeniy Polyakov wrote:

>Fixed matching bug - when we have match and have options to process
>not only first one but all, then we may rewrite fmatch value
>with FMATCH_WRONG parameters. Later osf will create decision based on
>the latest fmatch value, but not the fact that osf had match before.
>
>Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
>
>	Evgeniy Polyakov ( s0mbre )
>
>Only failure makes us experts. -- Theo de Raadt
>  
>

Applied to 2.4 and 2.6, but hand edited, you don't need to move the lock
for a local variable.

diff -u -r1.1 ipt_osf.c
--- osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c  22 Jul 2004 19:21:58 
-0000      1.1
+++ osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c  21 Aug 2004 22:10:02 -0000
@@ -412,6 +412,9 @@
        }

        read_unlock(&osf_lock);
+
+       if (fcount)
+               fmatch = FMATCH_OK;

        return (fmatch == FMATCH_OK)?1:0;
 }

>------------------------------------------------------------------------
>
>--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c	2004-07-18 00:10:43.000000000 +0400
>+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c	2004-08-20 21:55:22.000000000 +0400
>@@ -411,8 +413,11 @@
> 		}
> 	}
> 
>-	read_unlock(&osf_lock);
>+	if (fcount)
>+		fmatch = FMATCH_OK;
> 
>+	read_unlock(&osf_lock);
>+	
> 	return (fmatch == FMATCH_OK)?1:0;
> }
> 
>  
>
