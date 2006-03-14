From: "=?ISO-8859-1?Q?S=E9bastien_LAVEZE?=" <slaveze@gmail.com>
Subject: Libnetfilter_conntrack, CTNL_TEST
Date: Tue, 14 Mar 2006 10:15:27 +0100
Message-ID: <ca021ab30603140115g52e6301fj27ff030ed1d6aa2b@mail.gmail.com>
References: <ca021ab30603140111kf4fe35m89986d7a18fa51e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <ca021ab30603140111kf4fe35m89986d7a18fa51e7@mail.gmail.com>
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

Hi
I am developping an application using libnetfilter_conntrack
I first tried to run the example program ctnl_test, it seems to work
for events and table dumping but i still get errors and i would like
to know if  it's normal
Here is the output :

Test for libnetfilter_conntrack
NFNETLINK answers: Invalid argument
TEST 1: create conntrack (-22)
NFNETLINK answers: -EINVAL, make sure ip_conntrack_netlink is loaded
and you have NET_CAPABILITIES
TEST 2: dump conntrack table and reset (-524)
tcp      6 431960 ESTABLISHED src=3D192.168.31.42 dst=3D172.16.16.16
   sport=3D44582 dport=3D3128 src=3D 172.16.16.16 dst=3D192.168.31.42
sport=3D3128 dport=3D44582 [ASSURED] use=3D1
tcp      6 431960 ESTABLISHED src=3D192.168.31.42 dst=3D172.16.16.16
   sport=3D44583 dport=3D3128 src=3D172.16.16.16 dst=3D192.168.31.42
sport=3D3128 dport=3D44583 [ASSURED] use=3D1
tcp      6 431960 ESTABLISHED src=3D192.168.31.42 dst=3D172.16.16.16
   sport=3D44581 dport=3D3128 src=3D172.16.16.16 dst=3D 192.168.31.42
sport=3D3128 dport=3D44581 [ASSURED] use=3D1
tcp      6 431960 ESTABLISHED src=3D192.168.31.42 dst=3D172.16.16.16
   sport=3D44584 dport=3D3128 src=3D172.16.16.16 dst=3D192.168.31.42
sport=3D3128 dport=3D44584 [ASSURED] use=3D1
TEST 3: dump conntrack table (0)
TEST 4: get conntrack (-22)
TEST 5: update conntrack (-22)
NFNETLINK answers: Invalid argument
TEST 6: delete conntrack (-22)
TEST 7: Waiting for 10 conntrack events
Event number 1
Event number 2
Event number 3
Event number 4
Event number 5
Event number 6
Event number 7
Event number 8
Event number 9
Event number 10
TEST 7: Received 10 conntrack events (-1)
Test failed with error -1. Errors=3D5

I'm using a 2.6.15 kernel and i have all the needed modules
installed(ip_conntrack_netlink, ip_conntrack, nfnetlink,
nfnetlink_log...)

Thanks
Sebastien
