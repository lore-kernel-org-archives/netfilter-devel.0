From: "Osama Abu Elsorour" <osama.sorour@eformations.net>
Subject: conntrack management
Date: Sun, 31 Jul 2005 10:45:48 +0300
Message-ID: <12086.7584403188$1122837875@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

All

I always wondered why there isn't a more comprehensive way of managing
current conntrack entries, perhaps some sort of a user-space program that
can list conntracks in a more readable way using simple filters or matching
criteria.
This also leads to wondering why there isn't a way of forcefully destroying
specific conntracks without the need of resetting the modules, etc. I find
it very important specially when deleting a NAT rule while existing
connections are established.

I was thinking of building a tool to do both. On the first front, it seems
that it is quite doable (I am even thinking of making a kind of meta-tag
scheme, like string name-value pairs that can be attached to conntracks to
help ease up matching them for listing and/or deletion). The second front, I
am sure there is a good reason why it has not been done so far, I am just
not quite sure what it is.

Thanks
