From: "Hal Moroff" <halm90@gmail.com>
Subject: Is libiptc still the preferred library for manipulating tables?
Date: Fri, 11 May 2007 18:34:36 -0700
Message-ID: <e1663d820705111834g6aa95aa2ice26f26c816032b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I've been trying for awhile to find this out as well.


I'm working on an appliance and I need to dynamically insert/remove
rules based on
what's happening in the box. I prefer not to resort to
system("itpables yada yada yada")
and so have been trying to  use libiptc.  I've succeeded in inserting
/ removing simple
rules (based only on source IP and destination IP).  I'm struggling
now to understand
how to construct more complex matching rules (destination port).


There's this document:
   http://www.opalsoft.net/qos/libiptc/qlibiptc.html
which is incomplete, but mostly correct as far as it goes.  I offered
to  correct some
errors in the doc, but the author's email address is apparently invalid.


If anyone has any feedback / tips / samples I'd be grateful.
