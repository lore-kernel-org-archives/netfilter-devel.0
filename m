From: Mike Andersen <mike@src.no>
Subject: Re: Idea: Check session source and destination
Date: Thu, 29 Apr 2004 14:49:11 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <9D157DFC-99DB-11D8-8B47-000A957FD99E@src.no>
References: <Pine.LNX.4.44.0404271453370.23700-100000@filer.marasystems.com>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>,
	<netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404271453370.23700-100000@filer.marasystems.com>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Apr 27, 2004, at 15:00, Henrik Nordstrom wrote:

> netfilter conntrack requires traffic to be successfully forwarded to
> operate correctly. If you drop traffic then netfilter assumes that 
> packet
> was dropped and never forwarded.
>
> If you are mirroring then you must never drop or reject any packets as
> this will disturb the connection tracking, but you can make whatever 
> other
> decisions on the packets you like.

Ah.  This is a point where my assumptions has failed. :)

So, when I can't use DROP in iptables, can I do it with ebtables 
instead?  That is, is it possible to mark packets with iptables and 
drop them with ebtables?  Something like this:

iptables -t mangle -A PREROUTING -m conntrack --ctorigdst <int> -j 
ACCEPT
iptables -t mangle -A PREROUTING -j MARK --set-mark 1

ebtables -t nat -A POSTROUTING --mark 1 -j DROP

I know that this exact example does not work, but not why it fails.

I'm starting to believe that what I want to achieve here is impossible 
with iptables/ebtables, and any ideas on what I should try/explore 
would me most welcome.

mike
-- 
"It is a lesson which all history teaches wise men, to put trust in
  ideas, and not in circumstances."            --Ralph Waldo Emerson
