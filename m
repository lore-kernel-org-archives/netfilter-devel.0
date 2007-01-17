From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrackd-0.9.2 released
Date: Wed, 17 Jan 2007 03:49:11 +0100
Message-ID: <45AD8EA7.6030705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lwn@lwn.net
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Overview:

Conntrackd is the userspace daemon for the Connection Tracking System.
This daemon maintains a copy of the Connection Tracking System in
userspace. It is entirely written in C and is highly configurable and
easily extensible. Currently it covers the specific aspects of Stateful
Linux firewalls to enable High Availability (HA) solutions and can be
used as statistics collector of the firewall use.

Status:

This project is under development, people feeling brave are encouraged
to test a send nice reports ;)

Main changes:
- the unnofficial libraries are not required anymore
- a new NACK based protocol

More information available at:

http://people.netfilter.org/pablo/conntrackd/

P.S: There is a TODO file inside the tarball that includes some pending
stuff that needs to be done in case that you are thinking about
contributing to the project.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
