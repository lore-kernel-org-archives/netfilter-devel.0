From: Greg Stark <gsstark@mit.edu>
Subject: Masquerading connections terminated inside on both ends
Date: 29 Jun 2003 17:57:11 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87smps4keg.fsf@stark.dyndns.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I imagine this is a FAQ but I haven't seen it discussed. I have a server and a
client machine both on the inside of my masquerading router. I can access the
server from the outside fine, and i can access the internet fine from the
client. But I'm not clear how to arrange things so I can reach the server from
the client. 

Right now I have an entry in /etc/hosts to reach the server at its internal IP
address. However this isn't idea because then every client machine needs this
configuration or needs to use internal dns servers, and because then the
server needs to be specially configured and might not behave exactly the same
was in testing as it will from the outside.

My outside ip address is on the ppp0 interface. The server address is on eth1.
The client address is currently on eth1 as well but will eventually be on
eth2.

If I use masquerading rules based on the interface, which I prefer because it
seems simpler and less prone to abuse, then the machine doesn't even try to
NAT the packets since they're not coming in from ppp0.

If I write the rules to masquerade anything with a destination address of my
external ip address then it tries to DNAT the packets which is great, except
it doesn't do SNAT as well so the source address is still the internal address
on which interface the machine isn't expecting packets.

So I guess what I want the router to do for such connections is to do both
SNAT and DNAT. It should rewrite the packets coming from the client->router to
be from router->server and the return packets to be from router->client.

Is this even possible? What would the rules look like? 

It seems this is a common situation. Does everyone just special case their
internal machines to use the internal addresses of their servers? It seems I
would want to use the internal address for privileged connections, but use the
external address for accessing normal externally accessible services to be
sure that I'm getting the same behaviour someone outside would see.

-- 
greg
