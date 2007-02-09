From: Luis Campo Giralte <lcg223@tid.es>
Subject: Change Packet Payload
Date: Fri, 09 Feb 2007 10:10:18 +0100
Message-ID: <1171012218.4162.27.camel@LinuxCampo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi every one!

I have the next dude :D

im using libnetfilter_queue lib, its posible to change any value of the
packet, source address, icmp types, payload chars, or any data of the
packet received on the Handler (nfq_create_queue(h,0,&MyHandler,NULL))
and send it again with the correct checksum?

Thanks in advanced!
