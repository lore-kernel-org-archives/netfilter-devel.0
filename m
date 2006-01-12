From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH pom, re-post] h323-conntrack-nat: port to Linux 2.6.13+
Date: Thu, 12 Jan 2006 07:27:59 +0100
Message-ID: <43C5F6EF.5010601@trash.net>
References: <20060110194754.GA29354@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: GregScott@InfraSupportEtc.com, netfilter-devel@lists.netfilter.org,
	jcoco@meccorp.mec.edu, totya@ajkanet.hu,
	kadlec@blackhole.kfki.hu, ichimg@mail.dntis.ro
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20060110194754.GA29354@roonstrasse.net>
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

Max Kellermann wrote:
> h323-port_to_linux_2.6.13.patch
> - port to the new API in Linux 2.6.13 and 2.6.14
> - prerequisite:
>   svn copy patchlets/h323-conntrack-nat/linux-2.6.12 \
>     patchlets/h323-conntrack-nat/linux-2.6.13
> 
> h323-update_descriptions.patch
> - update descriptions, mention "Voice over IP" and "gnomemeeting"
>   rather than only "netmeeting"
> 
> 
> Please commit these to patch-o-matic-ng svn.

Directory copied and both patches applied, thanks.
