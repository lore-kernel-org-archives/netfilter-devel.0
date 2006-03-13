From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Sun, 12 Mar 2006 21:22:23 -0500
Message-ID: <BAY109-DAV1330DD37E6D3BA0FF46E0DB3E00@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl><4400A541.9080901@trash.net><BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl>
	<440960E4.80601@trash.net>
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
Sent: Saturday, March 04, 2006 4:41 AM
Subject: Re: New H.323 conntrack & NAT helper module


>
> I would expect incremental checksumming to be less expensive than
> redoing the entire checksum. I'll try to get a patch ready for
> testing this weekend, than we can compare the two approaches.
>

OK, I think you know much more of kernel than I do anyway, so I have
changed the code based on your patches. The new module (version 0.3)
is ready for download at
http://sourceforge.net/project/showfiles.php?group_id=158936.
The document at http://nath323.sourceforge.net is updated.

Following are the changes:

1. Added support for multiple TPKTs in one packet (suggested by Patrick 
McHardy)
2. Avoid excessive stack usage (based on Patrick McHardy's patch)
3. Added support for non-linear skb (based on Patrick McHardy's patch)
4. Fixed missing H.245 module owner (Patrick McHardy)
5. Avoid long RAS expectation chains (Patrick McHardy)
6. Fixed incorrect __exit attribute (Patrick McHardy)
7. Eliminated unnecessary return code
8. Fixed incorrect use of NAT data from conntrack code (found by Patrick 
McHardy)
9. Fixed TTL calculation error in RCF
10. Added TTL support in RRQ
11. Better support for separate TPKT header and data

Next week I'll release a newer version for these issues:

1. Separate ASN.1 code and data.
2. Sort H.323 data to avoid forwarding declarations
3. Add a parameter to make Q.931 signal expect for any address optional.
4. Add support for T.120.

Best regards,

Jing Min Zhao
