From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Sat, 18 Mar 2006 12:13:15 -0500
Message-ID: <BAY109-DAV470F9C3F267304522B744B3E50@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl><4400A541.9080901@trash.net><BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl><440960E4.80601@trash.net><BAY109-DAV1330DD37E6D3BA0FF46E0DB3E00@phx.gbl><44158920.30700@trash.net><BAY109-DAV757C3488B317953CCA29AB3E70@phx.gbl><4419281D.6050702@trash.net><BAY109-DAV69864489FACDF598B1718B3E50@phx.gbl>
	<441C39AE.6040805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
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


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Saturday, March 18, 2006 11:47 AM
Subject: Re: New H.323 conntrack & NAT helper module


> Jing Min Zhao wrote:
>> I tried, but it didn't work, so now I send it as compressed.
>
> Thanks, thats fine too.
>
>> The main new feature of this release is T.120 support. So chat, 
>> whiteboard,
>> file transfer and other T.120 applications are now supported.
>>
>> The second new feature is a parameter "gkrouted_only" for 
>> ip_conntrack_h323
>> module. If set it to 1, only calls from the gatekeeper will be forwarded
>> to the
>> registered endpoint.
>
> Since the H.323 helper behaves different than other helpers in this
> regard and many people just load all available helpers, I would prefer
> if it defaulted to off. If you agree I'm simply going to change this,
> no need to send a new patch.
>

Sorry, I forgot to say that the default value is 0. Sure you can change it.

>> Change log:
>>
>> 1. Added support for T.120 channels
>> 2. Added parameter gkrouted_only (suggested by Patrick McHardy)
>> 3. Splitted ASN.1 code and data (suggested by Patrick McHardy)
>> 4. Sort ASN.1 data to avoid forwarding declarations (suggested by
>> Patrick McHardy)
>> 5. Reset next TPKT data length in get_tpkt_data()
>
> Thanks a lot. I'll review the patch this weekend, if there are no
> new issues I'll put it in my 2.6.17 tree.
>
>

That's great.

Many Thanks!

Jing Min Zhao
