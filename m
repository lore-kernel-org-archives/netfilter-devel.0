From: Patrick McHardy <kaber@trash.net>
Subject: Re: bidirectional ip_conntrack_irc
Date: Thu, 12 Jan 2006 05:11:39 +0100
Message-ID: <43C5D6FB.5070303@trash.net>
References: <4dc54d760512300911o5c386f4n76c07d078d5142f8@mail.gmail.com>	
	<43BA675A.70101@trash.net>
	<4dc54d760601101707k1971896dx600e15af5b209a1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Wandersleb <sven.wandersleb@gmail.com>
In-Reply-To: <4dc54d760601101707k1971896dx600e15af5b209a1e@mail.gmail.com>
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

Sven Wandersleb wrote:
>>>is there any Plans to get ip_conntrack_irc working in both directions?
>>>Its sad to have connections called NEW, if in fact they are RELATED.
>>
>>What do you mean by "both directions"?
> 
> 
> ip_conntrack_irc only tracks my DCC connections when i send files to
> others on  irc. This is necessary because there needs to be a port on
> my NAT forwarded to my computer so that the otherone can connect.
> 
> If i receive a file from another user its not necesarry to open any
> ports, so this is ignored by ip_conntrack_irc. Yet the connection is
> (or imho should be considered) related to the main irc connection.

Ah, I see now, the helpers ignores packets in the other direction.
I'm going to look into if its easily possible to change this.
