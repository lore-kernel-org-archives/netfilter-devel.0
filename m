From: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>
Subject: RE: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 16:38:29 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <0C674B14EAEBD61196D900B0D03DB49F01C1EA7A@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>It is not possible to reliably identify HTTP traffic, and 
>further this is 
>extremely hard to do correctly at packet level simply because 
>you can not 
>at all see the protocol data unless you accept the session to 
>be set up 
>and even allow forwarding of protocol payload until the 
>protocol can be 
>reliably identified by its payload.
>
>The best way to do this reliably is by proxies. Set up a HTTP 
>proxy and have your clients configured to use this. Then block 
>any direct access to Internet not using the proxy.

Yes I think I should do it this way. Thanks.

>> Another question which I couldn't find an answer to is, when in the 
>> conntrack/NAT code is the ip_nat_info structure initialized
>
>It is set up by the NAT targets/helpers by calling 
>ip_nat_setup_info, or implicitly by the NAT table if there is 
>no NAT target in the hook.

Ok. Just to veryfy whether I understand everything correctly. First I have
to 
register a NAT helper and then in the helper's callback function I call 
Ip_nat_setup_info. Correct?
But now I have one more doubt There is another expect callback function in
the
Ip_nat_helper structure. What is the purpose of this? 
I reffered to the FTP ALG (FYI I am implementing a SIP ALG) and I found that

ip_set_nat_info is being called from there. 
When and how will this function be called?

Thanks & Rgds
Shobhit
