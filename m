From: Patrick McHardy <kaber@trash.net>
Subject: nfsim cmdline section alignment problems on x86_64
Date: Thu, 06 Jan 2005 13:26:00 +0100
Message-ID: <41DD2E58.9080800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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

Hi Rusty,

I ran into some alignment problems with the cmdline section on x86_64
with gcc 3.3.5. Entries are aligned to 32-byte, which causes every entry
to occupy 64 bytes. sizeof(struct cmdline_option) is 40 byte however, so
using them or calculating their number fails.

  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [18] cmdline           PROGBITS         0000000000540e80  00040e80
       0000000000000280  0000000000000000  WA       0     0     32

My quick fix was to pad the structure to 64 bytes, hopefully you have a
better idea :)

Regards
Patrick
