From: Bobo <boboaq@163.com>
Subject: How does a NAT-packet traverse?
Date: Fri, 14 Mar 2003 15:2:11 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030314070154.5FDA81CFB5E00@sm203.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org <netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



 Hello:

        Now,I  am studying how to setup Iptable rules,and I meet a question.

        I would like to know how netfilter  do with a packet which is the response of 

        a NAT-packet from the inside network?

        Where does netfilter do with these packets and give them original IP address?
  
       Will these packets pass through INPUT chains and go out from OUT chains?and  they are

       changed at the local process ?

        I am puzzled now .

       Hope to know of it soon .

      Thanks
