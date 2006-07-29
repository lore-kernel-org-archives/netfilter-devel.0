From: "Rajesh Mahajan" <rajeshmahajan09@gmail.com>
Subject: IMQ AND IP_Queue
Date: Sat, 29 Jul 2006 12:50:09 +0530
Message-ID: <c9961d450607290020t2c28c065g76483acacad16fbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
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

we r currently using kernel 2.6.12 and iptables 1.3
there is issue between imq and ip_queue
we r using imq for shaping
now we ip_queue module to be inserted
But it is unable to insert it is giving errors
FATAL: Error inserting ip_queue (/lib/modules/2.6.12-1-686
/kernel/net/ipv4/netfilter/ip_queue.ko): Device or resource busy
