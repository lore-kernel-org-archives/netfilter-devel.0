From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] convert mport to multiport
Date: Sun, 26 Sep 2004 16:27:38 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040926232738.GB2201@linuxace.com>
References: <415748E8.60000@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <415748E8.60000@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 27, 2004 at 12:55:36AM +0200, Pablo Neira wrote:
> Hi Patrick,
> 
> Attached a patch that puts mport and multiport together. It applies to 
> latest bk snapshot.
> 
> I've also added some clean ups like the use of  a count var inside the 
> ipt_multiport instead of using 65535 and the pflag set to mark the end 
> of the array of ports. I've tested and it works fine for me.
> 
> Also attached the patch for iptables and man page. If missing something, 
> please let me know.
> 
> regards,
> Pablo

Pablo - 

first of all, thanks for doing this -- it will come in handy in my scripts.

Minor nit:

@@ -146,6 +161,10 @@
                exit_error(PARAMETER_PROBLEM,
                           "multiport does not support invert");

+       if (invert)             
+               exit_error(PARAMETER_PROBLEM,
+                          "multiport does not support invert");
+       
        if (*flags)
                exit_error(PARAMETER_PROBLEM,
                           "multiport can only have one option");

this hunk looks redundant.


Phil
