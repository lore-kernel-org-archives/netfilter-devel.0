From: "Emiel Mols" <emiel@fulgor-hosting.nl>
Subject: RE: nfnetlink-ctnetlink with 2.4.27
Date: Wed, 20 Oct 2004 22:50:58 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <E1CKNQX-000696-00@deer.gmane.org>
References: <4176C27A.1030205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <4176C27A.1030205@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I did it by hand:

patch -p1 < linux.patch

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net] 
Sent: woensdag 20 oktober 2004 21:55
To: Emiel Mols
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: nfnetlink-ctnetlink with 2.4.27

Emiel Mols wrote:

>Hi,
>
> 
>
>During compilation of a 2.4.27 stock kernel (from kernel.org) patched with
>the nfnetlink-ctnetlink patch from the last pom-ng (patching goes well),
the
>following error occurs:
>  
>

Apparently it failed to apply linux.patch. Try applying it by hand.

Regards
Patrick
