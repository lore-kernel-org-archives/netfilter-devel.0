From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: GeoIP Extension
Date: Thu, 16 Nov 2006 13:07:24 -0000
Message-ID: <twig.1163682444.51274@bugmachine.ca>
References: <20061115224717.GA13622@utopia.cable.nu>
Reply-To: jix@bugmachine.ca
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David Balnaves" <david@utopia.cable.nu>,
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <20061115224717.GA13622@utopia.cable.nu>
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

On Wed, Nov 15, 2006, David Balnaves <david@utopia.cable.nu> said:

> Hi,

Hello!

> Does anybody know if somebody is maintaining iptables geoip?

Well, technically, there is someone, yes.

> 
> Where can I get the latest patches/source?
>

Patch-o-matic offers a new way to get external patchlets into pom :

IIRC, runme --download will do fine.

Unfortunately, I don't have much time right now to 1) bring my network up;
and 2) work on geoip or sync it with current kernel.

To work around my bads, please download geoip from

http://people.netfilter.org/peejix/patchlets/geoip.tar.gz

and probably need to patch with 

https://lists.netfilter.org/pipermail/netfilter-devel/2006-July/024982.html

I have not tried this patch myself.

I am sorry for the inconveniant. I will reserve some time to maintain and
enhance this patch during next years.

Best regards,
Samuel
