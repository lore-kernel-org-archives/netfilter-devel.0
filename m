From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 22:29:42 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703162021331.29521@yvahk01.tjqt.qr>
References: <DF74C782E6463841A9BD332297758881121069@FHCLUSRV-EX.dcs.fh-heidelberg.de>
	<45FABA87.4090601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, "Gladewitz,
	Robert \(FH\)" <Robert.Gladewitz@fh-heidelberg.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FABA87.4090601@trash.net>
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


On Mar 16 2007 16:40, Patrick McHardy wrote:
>
>> +++ linux-2.6.20.2/Documentation/ipt_PORTNETSCAN.txt
>> @@ -0,0 +1,389 @@
>> +Allgemein Informationen zum Modul ipt_PORTNETSCAN

If it's a match, make it lowercase.

>Luckily I speak german :)

Can't have that luxury.

>But seriously, we already had different portscan-detection matches
>submitted, but decided against merging them since its not clear
>what the benefit of detecting scans is. It clearly doesn't improve
>security since
>
>- you can just scan slow enough not to be detected

Speaking for chaostables, just have a look at section 9:
http://jengelh.hopto.org/p/chaostables/fw.html#se9
Either you scan so slowly that you do not get much of results, or you 
scan fast enough that you are detected.

>- you don't need to scan to crack something

move port 22 to rand(0,65535) and a scan is needed first to figure out 
where sshd is.


>diff -Naur linux-2.6.20.2.org/Documentation/ipt_PORTNETSCAN.txt linux-2.6.20.2/Documentation/ipt_PORTNETSCAN.txt
>--- linux-2.6.20.2.org/Documentation/ipt_PORTNETSCAN.txt	1970-01-01 01:00:00.000000000 +0100
>+++ linux-2.6.20.2/Documentation/ipt_PORTNETSCAN.txt	2007-03-10 14:33:15.000000000 +0100
>@@ -0,0 +1,389 @@
>+
>+--tree-depth [1|2|4|8|16|32]
>+Standard: --tree-depth 4
>+Diese Option gibt die Baumtiefe des Suchbaumes (Suchindex) (trace-tree /
>+berwachungsliste) an. Bei einer angegeben Baumtiefe von 1  wird  eine 
>+einfache  verkettete  Liste  als Suchindex verwendet. Bei eigenen
>+Testreihen hat sich eine Baumtiefe von vier als Optimum herausgestellt.
>+Bei den Tests wurde aber von mehr als 1000 gleichzeitigen Verbindungen
>+ausgegangen.
>+
>+--trace-time [Sekunden] (10-3600)
>+Standard: --trace-time 120 (2 Minuten)
>+Die Option trace-time gibt die Zeit in Sekunden an, welche eine Quelladresse
>+berwacht wird. Solange Pakete durch die Regel berprft  werden, beginnt
>+die berwachungszeit von neuem. Dies bedeutet, dass z.B. bei einem Wert von
>+20 in dieser Option der berwachungseintrag der Quelladresse erst dann 
>+entfernt wird, wenn dieser 120 Sekunden keine Prfung mehr erfordert hat,
>+d.h. dass in dieser Zeitspanne kein Paket durch die IpTables Regel zur 
>+berprfung an das Modul gesendet wurde. Dies ist in der Regel der Fall,
>+wenn der Rechner keine Verbindung mehr zum Zielsystem hat.

This sounds like -m recent --update ...

>+--block-time [Sekunden] (0-172800)
>+Standard: --block-time 3600 (1 Stunde)
>+Die Option block-time gibt die Zeit in Sekunden an, die die Quelladresse eines
>+Rechners gesperrt wird, falls eine der definierten Schwellwerte (Quotas) 
>+erfllt ist. Der Rechner wird im Falle des berschreitens eines Schwellwertes
>+(Quota) aus den berwachten Eintrgen gelscht und in die Ablehnungsliste 
>+verschoben. Diese Liste ist eine normale verkettete Liste im Speicher und
>+wird nicht zustzlich indiziert.

-m recent -j DROP

>+--clean-interval [Sekunden] (1-60)
>+Standard: --clean-interval 1 (1 Sekunde)
>+Diese Option legt das Intervall fest, nach dem veraltete Eintrge aus den 
>+berwachungs- und Ablehnungslisten gelscht werden. Zustzlich ist im Kernel
>+noch ein globales Intervall festgelegt, nach dem veraltete Eintrge aller
>+Konfigurationsumgebungen freigegeben werden.

-m recent --seconds

>+--port-scan-quota [Quota] (3-1000)
>+Standard: --port-scan-quota 10
>+Diese Option legt fest, ab welchem Schwellwert (Quota) ein Portscan erkannt 
>+wird. 
>+Ein Portscan wird angenommen bei Erfllung folgender Voraussetzung: 
>+(Zielports   /  Zieladressen)  > port-scan-quota

Sounds like -m psd.

>+Informationen ber den Modulzustand im proc-Dateisystem
>+-------------------------------------------------------

Use sysfs.

>+// Unabhngige Typdefinitionen

/* */

>+// StandardDefinitionen
>+#define DEFAULTTREEDEPTH        4              /* StandardTiefe des verwendeten Baumes */
>+#define DEFAULTDEBUGLEVEL       0              /* Debuglevel */
>+#define DEFAULTTRACETIME        120            /* 10 Minuten berwachen per Default (600 Sekunden = 10 Minuten) */
>+#define MAXTRACETIME            3600           /* 1 Stunde Maximal berwachungszeit (3600 Sekunden = 1 Stunde) */
>+#define DEFAULTCLEANINTERVAL    1              /* Jede Sekunde soll geprft werden, ob Eintrge veraltet sind */
>+#define MAXTCLEANINTERVAL       60             /* Maxmialer Wert fr clean-interval */
>+#define MAXUINT32               4294967295     /* Maximaler 32 BIT Unsigned Int */
>+#define MAXENDNODEENTRY         9999           /* Maximale Lnge in Vektoren der Werte DPT und DST einer EndNode */
>+#define DEFAULTPORTSCANQUOTA    10             /* Portscan Erkennung: Standardwert fr Verhltnis (Schwellwert) von Zieladresse zu Zielport (Zielports/Zieladressen) */
>+#define MAXPORTSCANQUOTA        1000           /* Maximalwert fr Schwellwert zur Portscan Erkennung */
>+#define DEFAULTNETSCANQUOTA     10             /* Netscan Erkennung: Standardwert fr Verhltnis (Schwellwert) von Zielport zur Zieladresse (Zieladressen/Zielports) */
>+#define MAXNETSCANQUOTA         1000           /* Maximalwert fr Schwellwert zur Netscan Erkennung */
>+#define DEFAULTBLOCKTIME        3600           /* Zeit, die ein Host als blockiert gilt, falls ein Port- oder Netscan erkannt wird */
>+#define MAXBLOCKTIME            172800         /* Maximale Zeit fr blocken einer Quelladresse (172800 = 2 Tage) */
>+#define DEFAULTDENYLISTCOUNT    10             /* Default Anzahl an Hosts in der DENY-LISTE (Blockierte Hosts) */
>+#define MINDENYLISTCOUNT        10             /* Minimale Anzahl an Hosts in der DENY-LISTE (Blockierte Hosts) */
>+#define MAXDENYLISTCOUNT        2000           /* Maximale Anzahl an Hosts in der DENY-LISTE (Blockierte Hosts) */
>+#define MINENDNODECOUNT         10             /* Minimale Anzahl an berwachten Eintrgen */
>+#define MAXENDNODECOUNT         20000          /* Maximale Anzahl an berwachten Eintrgen */
>+#define DEFAULTENDNODECOUNT     10000          /* Standard Anzahl an berwachten Eintrgen */
>+#define GLOBALCLEANUP           30             /* Globaler Cleanup-Interval */
>+#define DEFAULTCOMBINEDQUOTA    50             /* Schwellwert fr Zielhost + Zielports eines Quellrechners */
>+#define MAXCOMBINEDQUOTA        1000           /* Maximaler Schwellwert fr Zielhost + Zielports eines Quellrechners */ 
>+#define KERNELLINEMAX           1024           /* Maximale Lnge einer Ausgabezeile fr den Kernel (proc-Aufruf) */
>+#define KERNELPAGESIZE          4096           /* Pagesize im Kernel */
>+#define DEFAULTCHECKDENYENTRIES 0              /* Nur Deny-Liste berprfen */
>+
>+// Erkannte Probleme
>+#define REASONPORTSCAN       1                 /* Portscan wurde erkannt */
>+#define REASONNETSCAN        2                 /* Netscan wurde erkannt */
>+#define REASONCOMPINED       4                 /* Combined Scan wurde erkannt */
>+#define REASONUNKNOWN        1024

A ton of parameters you got there..

>+struct ipt_PORTNETSCAN_info
>+{
>+        unsigned int tree_depth;
>+        unsigned int trace_time;
>+        unsigned int clean_interval;
>+        unsigned int port_scan_quota;
>+        unsigned int net_scan_quota;
>+        unsigned int max_deny_entries;
>+        unsigned int max_trace_entries;
>+        unsigned int block_time;
>+	unsigned int combined_quota;
>+	unsigned short check_deny_entries;
>+};
>[...]
>+struct IptGlobalConfStruct
>+{
>+	struct PortNetscanEnv * FirstPortNetscan;        // Speichert den ersten Konfigurationeintrag (Konfigurationsumgebung)
>+	struct KernelOutLinePuffer * FirstOutLine;       // Kernelausgabeliste: Bei proc_read-Aufruf ist dies der Zeiger auf das erste Element der noch auszugebenen Liste
>+	struct KernelOutLinePuffer * LastPrintOutLine;   // Kernelausgabeliste: Letztes ausgegebenes Elemet
>+	struct KernelOutLinePuffer * LastAddOutLine;     // Kernelausgabeliste: Letztes hinzugefgtes Element
>+	unsigned int FailBuffer;                         // Kernelausgabeliste: Bei nicht ausreichenden Puffer, werden hier die Anzahl der bereits verarbeiteten Bytes angegeben
>+	unsigned int Conf_Count;                         // Anzahl der Konfigurationseintrge
>+	time_t LastCleanup;                              // Letzer globaler Aufrumablauf (Unix-Zeit)
>+};

Please adhere to CodingStyle ;-)

A lot of structures.

>+struct TreeNode 
>+{ 
>+		struct TreeNode *         Parent;        // bergeordneter Eintrag in Suchbaum (NULL, wenn in oberster Ebene)
>+		void *                    Childs;        // untergeordneter Eintrag 
>+		struct TreeNode *         Prior;         // vorheriges Element in gleicher Hierachieebene (NULL, wenn erster Eintrag in Hierachieebene)
>+		struct TreeNode *         Next;          // nchstes Element in gleicher Hierachieebene (NULL, wenn letzer Eintrag)
>+		u_int32_t                 TreeValue;     // Anteil an Suchbegriff
>+};

Use #include <linux/rbtree.h> instead of reinwhenting the wheel, perhaps.

>+	  PORTNETSCAN is an iptables module for the detection of PORT-, NET 
>+	  and COMBINEDSCANS using quotas. The usage is described in the 
>+	  accompanying document located at Documentation/ipt_PORTNETSCAN.txt

What are netscans / combinedscans?

>+menu "IP: Netfilter Configuration"
>+	depends on INET && NETFILTER
>+
>+config NF_CONNTRACK_IPV4
>+	tristate "IPv4 connection tracking support (required for NAT)"
>+	depends on NF_CONNTRACK

!? No, this should not be here...

>+++ linux-2.6.20.2/net/ipv4/netfilter/Makefile.orig	2007-03-09 19:58:04.000000000 +0100

Should not be here.

>+int Kernel_CreateProcmemPuffer(void)
>+{
>+	// Functionsvariablen
>+	struct PortNetscanEnv * TEMP = IptGlobalConf.FirstPortNetscan;
>+	unsigned int COUNTER         = 0;
>+	u_int32_t * IPPARTS          = (u_int32_t*)_malloc( sizeof(u_int32_t) * 4, GFP_KERNEL);
>+	unsigned short PARTSIZE      = 8; /* 32/4* */
>+	unsigned int TEXTLEN         = 0;
>+	char STRINGBUFFER[KERNELLINEMAX];
>+	
>+
>+	if (IptGlobalConf.FirstOutLine == NULL )
>+	{
>+
>+		spin_lock(&PORTNETSCAN_SPINLOCK);
>+
>+		snprintf(STRINGBUFFER,KERNELLINEMAX-1,"# IpTables PORTNETSCAN MODUL\n# --------------------------\n#\n");
>+		TEXTLEN += Kernel_CreateProcmemPufferAddEntry(STRINGBUFFER);
>+
>+		snprintf(STRINGBUFFER,KERNELLINEMAX-1,"G\tCount_Global_Conf: %d\n",IptGlobalConf.Conf_Count);
>+		TEXTLEN += Kernel_CreateProcmemPufferAddEntry(STRINGBUFFER);
>+
>+		snprintf(STRINGBUFFER,KERNELLINEMAX-1,"U\tUpdating_Time(Unix): %u\n#\n",(unsigned int)getunixtime());	
>+		TEXTLEN += Kernel_CreateProcmemPufferAddEntry(STRINGBUFFER);

Blargh. Also note that proc files are limited to PAGE_SIZE, which is most
likely exceeded with all this info.




Too much code (and too much unused or duplicate code) for what it does. We've
got ipt_psd (checking scans/time) for long enough, and recently chaostables
(checking connection behavior) joined the scene. I think we really exploited
all methods by now.




Jan
-- 
