From: Patrick McHardy <kaber@trash.net>
Subject: Re: rule limitations?
Date: Wed, 29 Aug 2007 20:53:15 +0200
Message-ID: <46D5C09B.7000708@trash.net>
References: <4D25F22093241741BC1D0EEBC2DBB1DA365FFCDB@EX-SEA5-D.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
To: "Nesser, Phil" <nesser@amazon.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4D25F22093241741BC1D0EEBC2DBB1DA365FFCDB@EX-SEA5-D.ant.amazon.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Nesser, Phil wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> For relatively obscure reasons, I am trying to build a set of rules that run into the hundreds of thousands.  I was experimenting on a Redhat Release 5 machine with 2.6.18 kernel and 1.3.5  iptables.  I was able to load around 340k rules before getting an error of iptables-restore: line XXXXXX failed.
> 
> So I try it out on a server (much beefier, 8G ram, dual quad core 2GHz proc) running the same kernel/iptables versions.  This time it died in the same way at about 40k rules.  After some research I found a log message on Vmalloc failures, so I figured what the hell and rebuilt the server using the 64 bit version of RH 5.  Now no more vmalloc failures, but still dies at around 40k entries.
> 
> I am more than happy to build a custom kernel if that what I need to do.  I have poked around the sources and it is not obvious what needs to change.
> 
> Any help would be appreciated.


What error message do you get (or if its too unspecific, what does
strace show)?
