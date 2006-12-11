From: Michael Rash <mbr@cipherdyne.org>
Subject: psad-2.0 release
Date: Mon, 11 Dec 2006 01:42:11 -0500
Message-ID: <20061211064211.GC10300@minastirith>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
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

psad is a Netfilter log analysis tool, and the psad-2.0 release is now
available:

    http://www.cipherdyne.org/psad/

This release will be discussed in my upcoming book "Linux Firewalls:
Attack Detection and Response":  http://www.nostarch.com/firewalls.htm

Here are some of the highlights:

- Completely re-factored Snort rule matching capability.  The Snort
  keywords ttl, id, seq, ack, window, icmp_id, icmp_seq, itype, icode,
  ipopts, and sameip are now supported directly through Netfilter log
  messages.

- Signature updates are now published on cipherdyne.org at the link
  below, and psad can download these signatures and put them in place
  within the filesystem with the new --sig-update command line argument.

    http://www.cipherdyne.org/psad/signatures

- Added the ability to parse Netfilter logs and generate CSV formatted
  output.  This is useful for visualizing Netfilter data with AfterGlow
  (http://afterglow.sourceforge.net).  I have used the --CSV mode along
  with AfterGlow to graphically represent two of the Honeynet scan
  challenges (#30 and #34) that include Netfilter log data:

    http://www.cipherdyne.org/psad/honeynet/scan30/
    http://www.cipherdyne.org/psad/honeynet/scan34/

- Enhanced --Analyze output to include a listing of the top scanned
  ports, top signature matches, and top attackers.  Here is an example:

    http://www.cipherdyne.org/psad/honeynet/scan34/psad-analysis.html

- Many other enhancements and a few bugfixes.  Here is the complete
  Changelog:

    http://trac.cipherdyne.org/trac/psad/browser/psad/tags/psad-2.0/ChangeLog

Please email me with any questions, comments, or suggestions.

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
