From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Orphaned expectations
Date: Wed, 21 Apr 2004 01:33:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4085B33A.2080805@eurodev.net>
References: <Pine.LNX.4.44.0404201250190.4160-100000@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
  kernel@linuxace.com
In-Reply-To: <Pine.LNX.4.44.0404201250190.4160-100000@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Chris Wilson wrote:

>Do you think that any other helpers might be vulnerable to the same 
>problem?
>  
>

I think that only helpers for udp based protocols. So, I think that it 
could be also reproduced with the amanda helper in a weird scenario 
since this helper only looks for patterns in packets which comes from 
server to client.

Actually, when an udp packet hits the connection tracking system for 
first time, in the ip_conntrack_in function:

a) a new conntrack is created.
b) a helper is asigned to this conntrack.
c) and if this helper exists (case of tftp helper), it is also called.

So now, with only an udp packet, we have a conntrack which is not 
confirmed with an expectation associated, and as Phil pointed out, if 
this conntrack is destroyed the expectation keeps there forever.

regards,
Pablo
