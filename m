From: FS <futurasci@gmail.com>
Subject: Strange ip_conntrack values
Date: Sun, 18 Jul 2004 12:22:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <ef83df6b040718032245f93c05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hi,

When I run the command 

grep ^tcp /proc/net/ip_conntrack | awk '{print $4}' | sort | uniq -c

I get these lines ...

     26 CLOSE
     11 CLOSE_WAIT
    883 ESTABLISHED
     57 FIN_WAIT
     34 SYN_RECV
    116 SYN_SENT
  23720 TIME_WAIT

the TIME_WAIT number seems very strange ... network interrupts
increased a lot three months ago and I couldn't find an explanation
for this. The number of our visitors didn't increased like this ...

For example, before this "event", network interrups from MRTG, went
down to nearly 0 at 4 AM, but now even at this hour they are at 1000
....

We are under RH 7.2 
2.4.26

I hope you could help me ...

Thanks a lot,

John
