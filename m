From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [ANNOUNCE] Linux Security Summit 2013 - CFP
Date: Wed, 12 Jun 2013 09:45:53 -0700
Message-ID: <51B8A5C1.8030108@schaufler-ca.com>
References: <alpine.LRH.2.02.1305061853410.31937@tundra.namei.org>
Reply-To: Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: keyrings@linux-nfs.org, gentoo-hardened@gentoo.org,
 kernel-hardening@lists.openwall.com, "C. Craig Ross" <ccr@linuxfoundation.org>,
 tomoyo-users-en@lists.sourceforge.jp, tpmdd-devel@lists.sourceforge.net,
 Audit-ML <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org,
 linux-crypto@vger.kernel.org, selinux@tycho.nsa.gov, lwn@lwn.net,
 ubuntu-hardened@lists.ubuntu.com, fedora-selinux-list@redhat.com
To: Linux Security Summit Program Committee <lss-pc@ext.namei.org>
Return-path: <ubuntu-hardened-bounces@lists.ubuntu.com>
In-Reply-To: <alpine.LRH.2.02.1305061853410.31937@tundra.namei.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/ubuntu-hardened>,
 <mailto:ubuntu-hardened-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/ubuntu-hardened>
List-Post: <mailto:ubuntu-hardened@lists.ubuntu.com>
List-Help: <mailto:ubuntu-hardened-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/ubuntu-hardened>,
 <mailto:ubuntu-hardened-request@lists.ubuntu.com?subject=subscribe>
Errors-To: ubuntu-hardened-bounces@lists.ubuntu.com
Sender: ubuntu-hardened-bounces@lists.ubuntu.com
List-Id: netfilter-devel.vger.kernel.org

On 5/6/2013 2:18 AM, James Morris wrote:
> ==========================================================================
>                  ANNOUNCEMENT AND CALL FOR PARTICIPATION
>
>                        LINUX SECURITY SUMMIT 2013
>                             19-20 SEPTEMBER
>                             NEW ORLEANS, USA
> ==========================================================================

Multiple Concurrent Security Modules? Really?

This talk will cover the ongoing work to update the
Linux Security Module (LSM) infrastructure to allow
multiple concurrent security modules.

The talk starts with a statement of the problem being
solved, that the existing infrastructure allows only
a single LSM (plus Yama) to be active at a time. The
rationale for the current scheme will be discussed as
well as what has changed so that the new scheme is in
the works.

The talk continues with a description of the externally
visible changes and the reasons they've been made.
The peculiar configuration issues with networking will
be covered in some detail. The additions in /proc/.../attr
will be noted.

Next the structure of the stacking mechanism is detailed,
with special attention to the allocation and freeing of
security blobs. The handling of networking hooks and
secids will be examined.

Finally, the current project plan and status will be
described.

>
>
> DESCRIPTION
>
>   The Linux Security Summit (LSS) is a technical forum for collaboration
>   between Linux developers, researchers, and end users.  Its primary aim
>   is to foster community efforts in analyzing and solving Linux security
>   challenges.
>
>   The format of the summit will be:
>   
>     * Refereed presentations
>     * Subsystem reports
>     * Breakout development sessions 
>
>
> WEB SITE
>
>   http://kernsec.org/wiki/index.php/Linux_Security_Summit_2013
>
>
> DATES / LOCATION
>
>   The Linux Security Summit for 2013 will be held across 19 and 20 September
>   in New Orleans, USA.  It will be co-located with LinuxCon, as well
>   as Linux Plumbers.
>  
>   Note that Linux Security Summit attendees and speakers must be registered
>   to attend LinuxCon.  See the LinuxCon site for details on registration,
>   travel, and accommodation:
>   
>     https://events.linuxfoundation.org/events/linuxcon
>
>   The Linux Security Summit CFP is now open, and will close on 14th June.
>   
>   Accepted speakers will be notified by 21st of June.
>
>
> WHO SHOULD ATTEND
>
>   The event is open to all registered LinuxCon attendees.
>   
>   You do not have to be a "security person" to attend -- we're seeking a
>   diverse range of attendees, and welcome the participation of general
>   developers, researchers, operations, and end-users.
>
>
> CALL FOR PARTICIPATION
>
>   The program committee currently seeks proposals for:
>
>   * Refereed Presentations:
>       45 minutes in length, including at least 10 minutes of discussion.
>       Papers are encouraged.
>
>  
>   Topic areas include, but are not limited to:
>   
>     * System hardening
>     * Access control
>     * Cryptography
>     * Integrity control
>     * Hardware security
>     * Networking
>     * Storage
>     * Virtualization
>     * Desktop
>     * Tools
>     * Management
>     * Case studies
>     * Emerging technologies, threats & techniques 
>     
>   Proposals should be submitted in plain text via email to the program
>   committee at:  lss-pc (_at_) ext.namei.org
>
>   Abstracts should be approximately 150 words in total.
>
>
> PROGRAM COMMITTEE
>
>   The Linux Security Summit for 2013 is organized by:
>
>     * James Morris, Oracle
>     * Serge Hallyn, Canonical
>     * Paul Moore, Red Hat
>     * Stephen Smalley, NSA
>     * Joshua Brindle, Quark Security
>     * Herbert Xu, Red Hat
>     * John Johansen, Canonical
>     * Kees Cook, Google
>     * Casey Schaufler, Intel
>     * Mimi Zohar, IBM
>
>   The program committee may be contacted as a group via email:
>
>      lss-pc (_at_) ext.namei.org
>    
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
