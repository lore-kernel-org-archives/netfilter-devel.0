From: Alex Ongena <Alex.Ongena@able.be>
Subject: Re: Conntrack and high avaibility
Date: Wed, 17 Sep 2003 17:04:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063811052.3843.78.camel@aolin>
References: <1063725970.2697.11.camel@sasa>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063811081-19886-87"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: diegows@linux.org.ar
In-Reply-To: <1063725970.2697.11.camel@sasa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format...

------------=_1063811081-19886-87
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
We have the same problem and have not yet found a fix.
Are we the only ones ?
Alex
On Tue, 2003-09-16 at 17:26, Diego Woitasen wrote:
> I need a firewall with HA, transparent to the user, but i have the
> problem of conntrack. When the stand-by firewall become active the
> conntrack is started from zero (all connection must be establish again).
> Exists a project to transfer conntrack information between firewalls?
> If not? This is feasible to do it? If this is feasible i want to start
> working on it.
> 
> Thanks! 


--
Security check on this e-mail has been done by aXs GUARD
(http://www.axsguard.com)


------------=_1063811081-19886-87--
