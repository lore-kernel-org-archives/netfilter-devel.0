From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 11:31:31 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D007D73.9030609@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> 
> This configuration can be done just fine with iptables as demonstrated in my 
> earlier message, but here we go again (but slightly different):
> 
> # Allow existing connections
> iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
> # Allow hidden net to initiate new connections (including connection pickup)
> iptables -A FORWARD -i eth0 -j ACCEPT
> # Drop anything else
> iptables -A FORWARD -j DROP

Sorry, I don't understand something ! :-/

Does that mean that you DROP all the ACKs, even those which are valid ?

Regards
-- 
Emmanuel

I am not a vegetarian because I love animals;
I am a vegetarian because I hate plants.
   -- A. Whitney Brown
