From: =?ISO-8859-15?Q?Tassilo_Sch=FCtz?= <tschuetz@avodaq.com>
Subject: [libipq] Buffer size
Date: Fri, 14 Jun 2002 20:21:07 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D0A3413.8030200@avodaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: eem1wc@eim.surrey.ac.uk, eem1wc@eim.surrey.ac.uk,
	eem1wc@eim.surrey.ac.uk
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 On Fri, 14 Jun 2002  eem1wc wrote

 > [1] how big is this buffer?
 > [2] how can i go about to solve this problem? I typically need to 
introduce a
 > round-trip delay of 500ms (i.e. 250ms from src to dest through the 
bridge)?
 > [3] can i do anything to enlarge this buffer?

Have a look at :
'Linux 2.4 Packet Filtering HOWTO' in chapter 7.4 under Special Built-In 
Targets

But I don't know, if the queue allways reserves a full ip-packet size 
(1500 byte) for
each packet. So maybe you can count with a sniffer the amount of packets 
that will
go through your bride in i.e. 250 ms and then adjust the 'Queue max. 
length' value.


Tassilo
