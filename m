From: Richard Allen <ra@ra.is>
Subject: Accept and remove
Date: Wed, 19 Mar 2003 14:08:57 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030319140857.GB21417@ra.is>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all.

I was wondering if there is a feature in iptables where I can add a rule
that matches for example a SYN packet and jump to a target that lets it
through and then removes the rule.
Basicly allowing me to add a rule to my firewall that says, "You can ssh in
once, after that you need to talk to me again."

I've tried to do this using the limits and it mostly works but when any
change hapens in the rules in the kernel, the counters seem to get reset
and that reopenes those "spent" rules again.

If not, I was considering to take the ACCEPT target and copy it to something
else (ACCEPTONCE) and making the necessary changes.  Is there any way for
targets to know which rule called them ?

Any help in this would be greatly appriciated. :)


-- 
Rikki.         --  RHCE, RHCX, HP-UX Certified Administrator.
               --  Solaris 7 Certified Systems and Network Administrator.
Bell Labs Unix --  Reach out and grep someone.
Those who do not understand Unix are condemned to reinvent it, poorly.
