From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: xt_MARK useless line
Date: Fri, 29 Dec 2006 17:54:07 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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

Hi,


in linux-2.6.20-rc2/net/netfilter/xt_MARK.c one can find

        if((*pskb)->mark != markinfo->mark)
                (*pskb)->mark = markinfo->mark;

would not it be simpler just to set the mark? Or are comparison-jumps 
like these 'cheaper' than assignments? (I don't think so.)

	-`J'
-- 
