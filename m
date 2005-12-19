From: samba <samba@embeddedinfotech.com>
Subject: port Triggering.
Date: Mon, 19 Dec 2005 14:17:54 +0530
Message-ID: <43A673BA.5000009@embeddedinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,
I have been trying to configure port triggering using iptables. Port 
triggering allows opening  of  inbound port for some interval of time 
based on some outbound traffic that originated from internal LAN. This 
is similar to how ftp is handled by ip_conntrack_ftp module. With port 
triggering, there will be no need to parse the control packet for data 
ports that needs to be opened, since the user already specifies the 
ports on which the ftp server will open connection for data.

Is such a feature supported by iptables and the netfilter framework, 
which enables/triggers some user defined  incomming ports based on the 
traffic going through some outgoing ports(user defined) ?

I have seen some discussion regarding this in the archives (June 2003). 
But could not get any conclusions. Please help.

Thanks in advance for any help
-samba
