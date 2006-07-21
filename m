From: "Emanuele Colombo" <colomboe@msec.it>
Subject: Send a packet at a specific time
Date: Fri, 21 Jul 2006 13:51:03 +0200
Message-ID: <e67264960607210451t5077dae1o3aaaf17286d1c01e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi! I'm developing a kernel module that should run on a pc configured
as a bridge. It should look for every packet that pass on the bridge
and, only for some packets, stop them and then let them go only at a
specific time.

The amount of time that these packets needs to hold is about some milliseconds.

My idea was to filter packets with an hook on POST_ROUTING and look
for packets that needs to be "temporary blocked". For these packets
I'm going to return NF_QUEUE, and then in my queue hook function make
them wait with the msleep function. The Netfilter Hacking HowTo says
"This has similar semantics to registering for a hook, except you can
block processing the packet", so I understand that my queue hook
function can block his execution with an msleep without problems.

Anyway, running this module on a bridge makes it hang, and I must
reset the pc. What's wrong? How can I make a work like this?

Thanks
Emanuele Colombo
