From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Port Expectation
Date: Wed, 25 Jun 2003 03:03:53 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F66YluLCTaogxL0000049f@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Greetings,

For this piece of code in ip_nat_ftp.c, why are we change the port to use? 
If your protocol uses the same protocol port number for both the src & dest 
port (in my case always 138 in both direction), I suppose there is no need 
to change the expected port to some other values?

++++++++++++++++++++++++++++++++++++++++++++++++++

  /* Try to get same port: if not, try to change it. */
  for (port = ct_ftp_info->port; port != 0; port++)
  {
	newtuple.dst.u.tcp.port = htons(port);
	if (ip_conntrack_change_expect(expect, &newtuple) == 0)
		break;
  }


    Ricky

_________________________________________________________________
Send a fun phone greeting to your friend! 
http://www.msn.com.sg/mobile/fungreetings/
