From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: How do I use ip_conntrack_destroyed?
Date: Wed, 03 Dec 2003 14:05:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCDD197.6050700@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hei!

I am writing a new target module which needs to be aware about the 
number of conntracks that are currently known for a particular 
destination. Thus, to make my counter I wish to detect when a conntrack 
is destroyed. I have noticed the following in ip_conntrack.h :

/* Call me when a conntrack is destroyed. */
extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);

So I guess it particularly fits with my needs. But what about using it?

Does it work so that I have to write something like:
ip_conntrack_destroyed = &my_counter_function
in my ipt_xxxx_target function and then do my stuff in my_counter_function?

Can anyone confirm/invalidate this, please?

             Emmanuel
