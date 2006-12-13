From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables-1.3.7
Date: Wed, 13 Dec 2006 10:02:42 +0100
Message-ID: <457FC1B2.6000703@trash.net>
References: <45769244.3060508@netfilter.org> <457FBFEA.4010300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <457FBFEA.4010300@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> it seems that the release has been signed with an expired key:
> 
> # gpg --verify iptables-1.3.7.tar.bz2.sig
> gpg: Signature made Mon Dec  4 14:20:20 2006 CET using DSA key ID CA9A8D5B
> gpg: Good signature from "Netfilter Core Team <coreteam@netfilter.org>"
> gpg: Note: This key has expired!
> Primary key fingerprint: 02AC E2A4 74DD 09D7 FD45  2E2E 35FA 89CC CA9A 8D5B
> 
> # gpg --list-keys CA9A8D5B
> pub   1024D/CA9A8D5B 2001-09-15 [expired: 2006-09-14]
> uid                  Netfilter Core Team <coreteam@netfilter.org>
> 
> I'd appreciate a clarification about this problem.


Yes, we currently don't have any other key.
