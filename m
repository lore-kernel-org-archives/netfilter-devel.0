From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: max ftp conntrack problem
Date: Wed, 5 Nov 2003 11:41:30 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311051131625.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


When we use leapftp to download from ftp server,the connection often 
broke for a while in case of large rate. the rate was about 500k.
When I checked the log on the netfilter gateway, I got the following 
message,

max number of expected connections 1 of ftp reached for 130.18.90.155->159.226.61.190, reusing
  
I search for the answer,and got the answer that when the server changes
from active mode to passive mode, this would happen.
But how to solve the problem?  We tried several ftp tools such as flashflx,
and it is always the same problem.
Thanks.
	
	
regards,
		
Jack Zheng
zhengcb@netpower.com.cn
	
