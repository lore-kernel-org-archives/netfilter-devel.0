From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: ip_contrack table full ?
Date: Sun, 16 Feb 2003 23:41:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <18436282631.20030216234147@habitat-b.de>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hello list,

  I got an issue with ip_contrack module. I have a router here, with
  ip_contrack enabled, because I need the REDIRECT target. Earlier
  this day, the system wrecked, because the ip_contrack table was
  obviously full. How could this happen, with just 6 users ?
  I assume every connection is put in that table, so it should be
  kinda 'big'. Is there any way to modify the size of that table. Or
  is it some sort of leak ? For example, if a connection was not
  closed properly, when does the entry in ip_contrack get dropped ?

  I hope somebody can help me on this, because if this happens with 6
  users, what is going to happen, when there's approx 1000 users ?

-- 
Best regards,
 DarKRaveR                          mailto:DarKRaveR@habitat-b.de
