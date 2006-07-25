From: Maik Hentsche <maik@mm-double.de>
Subject: bugreport ipt_CLUSTERIP
Date: Tue, 25 Jul 2006 08:26:18 +0200
Message-ID: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
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

Hi!
I tried ipt_CLUSTERIP and it crashed with the appended error message. 
Unfortunatelly, I was not able to get an account for bugzilla (neither 
automaticall nor by writing the administrator) for 2 weeks, so I try to 
put it here.

so long
Maik


Unable to handle kernel NULL pointer dereference at 0000000000000053 RIP:
<ffffffff880c46da>{:ip_tables:ipt_do_table+188}
PGD 7e53c067 PUD 7d172067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: af_packet ipt_CLUSTERIP iptable_filter ip_tables 
x_tables ipv6 hw_random i2c_amd756 i2c_amd8111 i2c_core generic amd74xx 
e1000 tg3 ide_cd cdrom rtc unix
Pid: 3068, comm: rcp.statd Not tainted 2.6.17.3-egde #1
RIP: 0010:[<ffffffff880c46da>]
