From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Deleting Connection Tracking information
Date: Mon, 8 Jul 2002 14:06:06 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207081406.06870.hno@marasystems.com>
References: <AE696B0F5B44A348B8D18E40F976D9571BA92E@mailsrv.etagon.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1255"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Tsachi Sharfman" <Tsachi_Sharfman@etagon.com>,
	<netfilter@lists.samba.org>, <netfilter-devel@lists.samba.org>
In-Reply-To: <AE696B0F5B44A348B8D18E40F976D9571BA92E@mailsrv.etagon.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Tsachi Sharfman wrote:

> 1.	Is my assumption correct?

Yes. Deleting the conntrack entry will make the next packet "NEW".

> 2.	Is the answer to the first question is yes, how can I delete connection
> tracking information?

See ctnetlink.. under development..

See also the MASQUERADE target.

What I do not understand is why you want to do this..

Regards
Henrik
