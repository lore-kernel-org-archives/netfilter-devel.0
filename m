From: Herve Eychenne <rv@wallfire.org>
Subject: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 27 Nov 2003 05:28:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127042854.GE1084@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Yet another thing to be patched that would probably take more time
being added to TODO list than being done. ;-)

# cat /proc/net/ip_tables_targets
REJECT
TCPMSS
LOG
MASQUERADE
TOS
DNAT
SNAT

ERROR
#

Hmmm... well, "\nERROR\n" seems to be an intruder, don't you think?
I looked at the code, and this ERROR target seems to be a marker for
the beginning of user-chains... but you will agree with me that this
implementation detail has absolutely nothing to do in a target listing
publicly available to userspace.
I would have been happy to write a small patch to fix this, but as I
cannot really explain the presence of the preceding '\n' after a quick
look, I prefer to leave that "removal" to more experienced people.
Thanks in advance.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
