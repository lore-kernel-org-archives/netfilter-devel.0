From: Arne Bernin <arne@alamut.de>
Subject: conntrack sync via userspace ?
Date: Wed, 03 May 2006 23:22:22 +0200
Message-ID: <1146691342.2360.51.camel@morannon.athome>
Mime-Version: 1.0
Content-Type: text/plain
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

after playing a bit with ct_sync and finding out that it does not seems
being actively developed i wonder whether it would be possible to do the
syncing of conntrack tables over different machines using a user space
daemon and libnfnetfilter_conntrack ? Is this a possible way , or a no
go because of limitations in the conntrack lib , speed or something else
i am not aware of ?
I thought before digging to deep into it right now, i just ask the
people who should know, sorry about my lazyness. ;-)

--arne

-- 
Arne Bernin <arne@alamut.de>

http://www.ucBering.de
