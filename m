From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: U60: no iptables
Date: Sat, 08 Oct 2005 13:02:09 +0200
Message-ID: <4347A731.7010509@frankengul.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: debian-sparc@lists.debian.org
Return-path: <bounce-debian-sparc=debian-sparc=m.gmane.org@lists.debian.org>
To: netfilter-devel@lists.netfilter.org
Resent-Message-ID: <0vfjzD.A.bu.0c6RDB@murphy>
List-Post: <mailto:debian-sparc@lists.debian.org>
List-Help: <mailto:debian-sparc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-sparc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-sparc-request@lists.debian.org?subject=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

Hi there.

Being the owner of a two-way U60, I've been happy with it until 2.6.11.6.

The machine is a 2x300Mhz Uii with 1536Mb of memory and 2 scsi internal 
disk.

Since 2.6.12, I'm unfortunately unable to use it as gateway box, since 
the installation of iptables
cause a OOPS in the ipt_mangle.

I'm unable to send you the trace now because once it happened, it is not 
written on the files, only on the console.

This oops happens from the 2.6.12.x to the 2.6.13.x - not tried the 
2.6.14-rc.
It is related to the iptables subsystem.
It also happen with the official debian kernel (2.6.12-1-smp).

I'll try this week-end to setup early 2.6.12-rcx to check when the 
problem occured.

I will post the oops as soon as I write it down.
How can I get the copy of the trace without handwriting ?
What is the information relevant in the oops ?  (register + stack trace ?)

    Seb
