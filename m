From: Kishore Dharmavaram <kishored@servgate.com>
Subject: iptable_nat module slows/hoses my Redhat 9.0 box
Date: Thu, 11 Dec 2003 21:47:25 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B20EF@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter@lists.netfilter.org'" <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi All,

I find that after inserting "iptable_nat" module on my RH9.0(2.4.20-19.9)
box, session-setup(ip_conntrack)  performance gets very bad. 

Details of my test and results are as follows:
-I used 2.4.20-19.9 kernel on my RH9.0 box and I inserted "ip_tables",
"iptable_filter" and "ip_conntrack" modules.
-There are only INPUT, FORWARD, OUTPUT chains all with policy as ACCEPT
with no other rules/chains and "no" NAT rules.
-I used IXIA to send UDP packets continuously at 7Mbps rate to
20,000(incrementing) destination IP addresses through the RH9.0 box.
-I  find by doing "fgrep ip_conntrack /proc/slabinfo"  that 20,000 sessions
were created within 1 second and RH9.0 box was behaving normally, 60%CPU
idle.
-I stopped the test, did "insmod iptable_nat" on my RH9.0 and after all
existing ip_conntrack sessions have expired I reran the test again.
-My RH9.0 box got very busy, I even couldn't type any command on Linux
shell, and only some UDP traffic was going through the box at 200Kbps rate.
-After I stopped the test RH9.0 box returned to normal state and I found by
doing "fgrep ip_conntrack /proc/slabinfo" that only about 8,000 sessions
were created.

I am wondering why "iptable_nat" is slowing doing the box so much when I
don't have any NAT rules defined.

Do you guys know of any netfilter patches made to address/fix this issue?.
Any help willbe appreciated.

Thanks,
Kishore




 
