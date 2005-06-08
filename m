From: Christian Hentschel <chentschel2@arnet.com.ar>
Subject: Re: NAT reservations
Date: Wed, 08 Jun 2005 20:37:35 -0300
Message-ID: <1118273855.1948.15.camel@www.l-chr.com.ar>
References: <200506081943.j58JhbP14554@webserver5.arnet.com.ar>
	<Pine.LNX.4.62.0506082209470.6488@kaber.coreworks.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	hidden@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0506082209470.6488@kaber.coreworks.de>
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

> I want to create an expectation that expects incoming calls when the
> Gatekeeper replies with an RCF (Registration Confirm), but if we do NAT,
> the call signaling address in the RRQ needs to be NATed before the final
> port is known. So the only solution is to create the expectation
> immediately and cancel it after some timeout or when an Registration
> Reject is seen.

mm.. i see. But is it worth doing that?. I mean if u have a ptp call
without RAS signalling u won't have this situation. Maybe registering
the module to look for RAS and h225 signalling port would be ok. ie. udp
171{8,9} and tcp 1720. 
I think RAS signalling separated from h225/Q931 signalling, cisco, ie,
have ras fixup and h255 fixup, but this may be is not a happy example
anyways =P

> Same problem with Registration Confirm. It contains the call signaling
> address of the Gatekeeper, but there is nothing to expect because every
> signaling connection is preceeded by admissionRequest/admissionConfirm,
> which contain the address again. But it should be NATed similar to the
> ones in the admission messages, which can't be done reliably at all.

This would be the same i think. Letting through h225signalling port 1720
should be ok, and h245 and RTP stuff will be the dynamic data to
expect/mangle.

I hope this helps and sorry for my english.. :)
Regards,

-- 
Christian Hentschel <chentschel2@arnet.com.ar>
