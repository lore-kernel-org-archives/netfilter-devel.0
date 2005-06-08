From: Patrick McHardy <kaber@trash.net>
Subject: Re: NAT reservations
Date: Wed, 8 Jun 2005 22:16:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0506082209470.6488@kaber.coreworks.de>
References: <200506081943.j58JhbP14554@webserver5.arnet.com.ar>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279739137-1094524475-1118261799=:6488"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	hidden@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: chentschel2@arnet.com.ar
In-Reply-To: <200506081943.j58JhbP14554@webserver5.arnet.com.ar>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279739137-1094524475-1118261799=:6488
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 8 Jun 2005 chentschel2@arnet.com.ar wrote:

> Mensaje citado por: Patrick McHardy <kaber@trash.net>:
>
>> I\'m currently working on the H.323 connection tracking helper and
>> need to NAT addresses that are later used in an expectation, but
>> I don\'t want to create the expectation immediately.
>
> This is just to fulfill my curiosity. Is there some special reason for th=
is?.
> I=B4m very interested in this, but I think i don=B4t really get your poin=
t :(

There are a couple of cases where it would be useful.
For example H.225 RAS RRQ (Registration Request) messages to Gatekeepers
contain the call signaling address of the Endpoint that registers.
I want to create an expectation that expects incoming calls when the
Gatekeeper replies with an RCF (Registration Confirm), but if we do NAT,
the call signaling address in the RRQ needs to be NATed before the final
port is known. So the only solution is to create the expectation
immediately and cancel it after some timeout or when an Registration
Reject is seen.

Same problem with Registration Confirm. It contains the call signaling
address of the Gatekeeper, but there is nothing to expect because every
signaling connection is preceeded by admissionRequest/admissionConfirm,
which contain the address again. But it should be NATed similar to the
ones in the admission messages, which can't be done reliably at all.

Regards
Patrick
--279739137-1094524475-1118261799=:6488--
