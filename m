From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: dest addr using transparent proxy...
Date: Fri, 22 Nov 2002 19:03:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021122180321.GA25615@balabit.hu>
References: <20021114092244.92383.qmail@web40908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rajesh Mishra <rajesh_mish@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20021114092244.92383.qmail@web40908.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 14, 2002 at 01:22:44AM -0800, Rajesh Mishra wrote:
> I just started using the transparent proxy
> functionality and wanted to know how to get the
> destination IP address in my proxy server.

search google for SO_ORIGINAL_DST (hint it is a getsockopt)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
