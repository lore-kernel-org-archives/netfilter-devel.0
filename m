From: kalpesh@kalupurbank.com
Subject: help
Date: Sat, 8 Mar 2003 11:40:17 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <65256CE2.001F9E17.00@vikramnt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

help

Slow respose after using IPTABLES

Hi all,
My mail server is runnig on Redhat 7.2 with Sendmail.
Now I want to use IPTABLES for the Security Point of view. For this I made
test server and implemented IPTABLES on it. But after using IPTABLES
respose from the server is SLOW  when i use POP3 clients but it works.

I am using following script.

# Deny All

/sbin/iptables -P INPUT DROP
/sbin/iptables -P FORWARD DROP
/sbin/iptables -P OUTPUT DROP

# Local host

/sbin/iptables -A INPUT -s localhost -d localhost -j ACCEPT
/sbin/iptables -A OUTPUT -s localhost -d localhost -j ACCEPT

# ICMP

/sbin/iptables -A INPUT -s $INTRANET  -d $MYHOST -p icmp -j ACCEPT
/sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET  -p icmp -j ACCEPT


# SMTP

/sbin/iptables -A INPUT -s $INTRANET -d $MYHOST -p tcp --dport smtp    -j
ACCEPT
/sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET -p tcp --sport smtp   -j
ACCEPT

# POP3

/sbin/iptables -A INPUT -s $INTRANET -d $MYHOST -p tcp --dport pop3    -j
ACCEPT
/sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET -p tcp --sport  pop3   -j
  ACCEPT

Any suggestions ? help ? Please

with warm regards

kalpesh
