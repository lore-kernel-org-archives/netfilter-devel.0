From: "Eddie Shi" <eddieshi@broadcom.com>
Subject: ftp client hang
Date: Fri, 15 Nov 2002 11:35:24 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00b601c28cde$24ce1870$018f030a@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	netfilter-devel@lists.samba.org
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
  I am using the 2.4.17 kernel with newnat patch. When I use ftp with
passive mode off, the ftp client would hang if client tries to get a file
which does not exist.

  Does anyone have similar problem? My router is masquerading 192.168.1.2 ->
63.206.100.200


  1. ftp oss.sgi.com
    login
    password:

  ftp> cd pub
  ftp> get junk	  ***junk does not exist in the directory***

     200 PORT command successful
     500 Can't open junk: No such file or directory

  ftp> ls

     *** this would hang the client****


    I then patched the latest ip_conntrack_ftp.c and ip_nat_ftp.c , the
resuld is the same.

    When "ls" is issued, the ftp server sees the following from ethereal
dump:
      Request: PORT 63,206,100,200,4,88
      .
       Response: 200 PORT command successful
       Request: RETR junk
       Response: 550 junk: NO such file or directory
      .
      Request: PORT 192,168,1,2,4,89         **** I think here is the
problem when "ls" command is issued ******
      Response: 502 Illegal PORT command

    The following entry in /proc/net/ip_conntrack

    EXPECTING: proto=6 src=128.167.58.27 dst=63.206.100.200 sport=0
dport=1112


   Please include me in the response since I am not in the mailing list.
   Thanks



 Eddie
