From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [RFC] matching tproxied packets
Date: Wed, 5 Jun 2002 15:45:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206051545.27593.hno@marasystems.com>
References: <Pine.LNX.4.33.0206051233530.8715-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <Pine.LNX.4.33.0206051233530.8715-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> This is a good question. Probably it is better to add a (general) 'flags'
> field. But I have no idea for what else we could use it :-)

My opinion: Just add a bitfield. If other needs to add other small fields in 
the future they can add it next to yours. The compiler will pack them nicely.

Hmm.. btw, isn't there plenty of space in the ->status field? From what I can 
tell only 3 out of 32 bits is defined in this field. Should be possible to 
shrink it to a char or short, giving room for several more flag fields 
without increasing the size of a conntrack entry.. 

Regards
Henrik
