From: ChungLiang <david@cobra.ee.ntu.edu.tw>
Subject: Re: L2TP protocol source port number changed
Date: Thu, 22 May 2003 14:25:57 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECC6D75.3000708@cobra.ee.ntu.edu.tw>
References: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw> <20030522055921.GA24297@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear Patrick,

	Thanks for your reply and I am sorry for my typo.

	Maybe I did not state my question clearly enough so I will do it again.
>From what I seem on the packets, it seems that microsoft L2TP server
will only response with both source and destination port set to 1701.

	And I have seen linux build which works. This means that for different
computers connecting through this linux route's netfilter to have 1701
as both source and destination port number. So it works.

	Now I have build my own linux router and found out the second computer
will not have the source port staying at 1701 but changing to 1024 by
the NAT. I am wondering what should I do to make this go away and stay
at 1701. Thanks.

	Best regards,
	ChungLiang

Patrick Schaaf wrote:
>>	I have tried L2TP protocol under netfiler and it seems the second
>>connection's source port will be changed to 1024 from 1071.
> 
> 
>>From reading the RFC for L2TP, it is clear that only the first,
> initial packet establishing a new tunnel, will have 1701 (not 1071,
> that was probably a typo?) as the _destination_ port. By answering
> with different ports, a LNS can switch the operational tunnel around
> onto other ports - and even onto a different endpoint IP address!
> 
> The RFC even alludes to problems with NAT devices (and consequently
> stateful tracking).
> 
> In practise, at least between ERX and Cisco systems, this appears
> to be avoided, and communication runs source/dest port 1701.
> However, by misconfiguring the Cisco LNS, I could clearly see
> the endpoint IP address switching. It is not unlikely that once
> the 2^16 session IDs of a single tunnel run out, that the Cisco
> will switch to an additional tunnel on nonstandard ports.
> 
> For a proper solution, somebody would need to write a conntrack helper
> for L2TP, to setup expectations / create RELATED connections, by analyzing
> the tunnel establishment. As far as I can see, such a setup would then
> provide a security hole enabling an attacker to permit more or less
> arbitrary UDP traffic, if they can hand-craft a suitable packet. So one
> needs to be very careful. NOTE: that's a vague feeling of mine, I have
> not analysed this deeply.
> 
> best regards
>   Patrick
> 
> 
