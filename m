From: "Ed White" <ed@overminder.com>
Subject: invalid packets default behaviour
Date: Fri, 29 Nov 2002 19:59:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c297d9$71eab5e0$022aa8c0@thunder>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I've read this old mail on archive
(http://lists.netfilter.org/pipermail/netfilter/1999-September/002583.html)

/*
Well, you have to keep a sliding map of data in the current window
anyway, and a pointer to the last match you're looking for.  It's like
this:

1) Checksum packet.  If bad TCP checksum, drop it.
2) If it's outside current TCP window, drop it.
3) If packet's data doesn't match what's already in the map, or drop it.
4) Place packet in map.
5) If there are `holes' in the map before this packet, drop it.
6) Search from last match pointer to first hole: for each match,
   flag it (return, call matchfn, whatever your library does) and
   update match pointer.
*/

Is that part related to the default Netfilter behaviour ?

I would like to know if today Netfilter automatically drop invalid
packets(header too short, bad checksum, etc...)
If no, is there a module under development to do it ?
How could I log them ?

Thanks.


	Ed
