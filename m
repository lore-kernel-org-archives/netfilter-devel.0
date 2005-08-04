From: Pawel Sikora <pluto@agmk.net>
Subject: libipt_geoip.c doeasn't build with 2.6.12+conntrack-event-api.
Date: Thu, 4 Aug 2005 21:42:27 +0200
Message-ID: <200508042142.27778.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
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

Hi,

The conntrack-event-api patch removes from 2.6.12
the NFC_* entries from linux/netfilter.h.
finally geoip userspace module doesn't build.

Could someone netfilter guru fix this?

Regards,
Pawel.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke
