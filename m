From: "Qiang" <qzhang@endeavorsystems.net>
Subject: how to release resource when rule is deleted {Virus Scanned}
Date: Thu, 29 Apr 2004 11:10:13 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404291514.i3TFEIPW008962@localhost.localdomain>
References: <427EA2C2-9787-11D8-8B47-000A957FD99E@src.no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <427EA2C2-9787-11D8-8B47-000A957FD99E@src.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



If I have a match or target which will need to initialize some memory
resource at check_entry,   can I have a chance to release the resource when
the rule is deleted?

Thanks
Qiang
