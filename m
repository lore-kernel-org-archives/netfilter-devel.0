From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: the  limit of the rate of syn packets of each host
Date: Tue, 22 Jul 2003 15:42:9 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307221533625.SM00840@zhengcb>
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


	i'm trying to find some solutions to my problem. i want to limit the rate of syn packets from all the single host. if the syn rate from a certain host is too fast,it should be logged.
	the 'limit' match could not solve ,'cause it could not monitor on a single host. and the connlimit patch in the patch-o-matic also could not do what i want,it does not  care about packet rate.
	so is there some solution to that?
	thanks.
	
jack zheng
zhengcb@netpower.com.cn
zhengchuanbo@sina.com
	
