From: Herve Eychenne <rv@wallfire.org>
Subject: Re: how to flush conntrack entry?
Date: Tue, 25 Nov 2003 16:30:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031125153043.GC1082@eychenne.org>
References: <003201c39f75$3e40a5c0$0200200a@wangle> <20031103074343.GL1536@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	sina <wanglonge@vip.sina.com>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20031103074343.GL1536@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 03, 2003 at 08:43:43AM +0100, Harald Welte wrote:

 Hi,

> it will not stop working 'obviously'.  It will just stop working because
> you were using MASQUERADE, and MASQUERADE [still] has the policy of
> flushing all conntrack/nat entries associated with the IP address of the
> outgoing interface.  Would you be using SNAT, it would continue to work.

By the way, Rusty has written a bit of code during the workshop, that
enables MASQUERADE not to flush current connections if the interface
address didn't change after the interface has come up again.
What is the status regarding its inclusion into vanilla kernel?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
