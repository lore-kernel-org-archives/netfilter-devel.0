From: Laurent Guyon <laurent.guyon@adelux.fr>
Subject: QUEUE target and IPT_CONTINUE verdict ?
Date: Fri, 13 May 2005 17:29:39 +0200
Message-ID: <200505131729.39430.laurent.guyon@adelux.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

(sorry for my bad english, i'm french ;)

Just wondering why we can't return an IPT_CONTINUE verdict at the end of the 
QUEUE target.

I understand that the QUEUE target registers on a Netfilter queue_handler 
(that is a special kind of hook), and then it must call nf_reinject in the 
end.

I understand too that the nf_reinject function accepts only NF_ACCEPT, 
NF_DROP ... verdicts, but why ? Is it technically impossible to give 
nf_reinject an IPT_CONTINUE verdict and implement the relevant code to 
let packets continue their path in the rules ? or anyone hadn't ever thought 
about such a feature ?

In fact i need to put packets ine the QUEUE target to process them in 
userspace, and then reinject them in Netfilter, but they must continue their 
path in the rules.

Thanks a lot,

Laurent
